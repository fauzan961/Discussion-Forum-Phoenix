defmodule DiscussWeb.CORSHeaders do
  def discuss_cors_headers() do
    [
      "cache-control",
      "accept",
      "accept-encoding",
      "authorization",
      "content-type",
      "content-range",
      "content-disposition",
      "dnt",
      "x-iap",
      "origin",
      "user-agent",
      "x-csrftoken",
      "x-requested-with",
      "tus-resumable",
      "upload-length",
      "upload-metadata",
      "upload-offset",
      "tus-checksum-algorithm",
      "upload-checksum",
      "x-app-platform",
      "baggage",
      "sentry-trace"
    ]
  end
end
