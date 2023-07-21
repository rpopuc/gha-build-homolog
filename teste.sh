curl \
  --request GET \
  --silent \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_ACCESS_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --url "https://api.github.com/repos/rpopuc/gha-build-homolog/actions/workflows/deploy.yaml/runs" | jq -r '.workflow_runs[0].status'