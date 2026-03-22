// Replace the old URL imports with these clean ones:
import { serve } from "std/http/server.ts";
import { createClient } from "supabase";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // 1. Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 2. Initialize Supabase Admin
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    );

    // 3. Get User from Auth Header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) throw new Error("Missing Authorization header");

    const { data: { user }, error: userError } = await supabaseAdmin.auth
      .getUser(authHeader.replace("Bearer ", ""));
    if (userError || !user) throw new Error("Invalid user token");

    // 4. Parse Request Body
    const { resumeId, jobDescription } = await req.json();
    if (!resumeId || !jobDescription) {
      throw new Error("resumeId and jobDescription are required");
    }

    // 5. Fetch Profile & Resume Data
    const { data: profile, error: profileError } = await supabaseAdmin
      .from("profiles")
      .select("credits, is_pro")
      .eq("id", user.id)
      .single();

    if (profileError || !profile) throw new Error("User profile not found");

    const { data: resume, error: resumeError } = await supabaseAdmin
      .from("resumes")
      .select("content")
      .eq("id", resumeId)
      .single();

    if (resumeError || !resume) throw new Error("Resume not found");

    // 6. Security Check: Credits
    if (!profile.is_pro && profile.credits <= 0) {
      return new Response(
        JSON.stringify({ error: "No credits remaining. Upgrade to Pro!" }),
        {
          status: 402,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // 7. Call OpenAI
    const openaiResponse = await fetch(
      "https://api.openai.com/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-4o",
          messages: [
            {
              role: "system",
              content:
                "You are an expert career coach. Tailor the provided resume content to match the job description perfectly while maintaining honesty.",
            },
            {
              role: "user",
              content: `Resume: ${
                JSON.stringify(resume.content)
              }\n\nJob Description: ${jobDescription}`,
            },
          ],
          temperature: 0.7,
        }),
      },
    );

    if (!openaiResponse.ok) {
      const errorData = await openaiResponse.json();
      throw new Error(
        `OpenAI API error: ${errorData.error?.message || "Unknown error"}`,
      );
    }

    const aiResult = await openaiResponse.json();
    const tailoredText = aiResult.choices[0].message.content;

    // 8. Deduct Credit (if not Pro)
    if (!profile.is_pro) {
      await supabaseAdmin
        .from("profiles")
        .update({ credits: profile.credits - 1 })
        .eq("id", user.id);
    }

    // 9. Return success
    return new Response(
      JSON.stringify({ tailoredText }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      },
    );
  } catch (err) {
    const error = err instanceof Error ? err : new Error("Unknown error");
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      },
    );
  }
});
