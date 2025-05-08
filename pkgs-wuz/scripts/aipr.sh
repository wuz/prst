PROTECTED_BRANCHES=("main" "master" "develop" "release")

# Check if the current branch is protected
if [[ "${PROTECTED_BRANCHES[*]} " =~ $CURRENT_BRANCH ]]; then
  echo "You are on a protected branch: $CURRENT_BRANCH"
fi

STAGED_FILES=$(git diff origin/main --cached --name-only)
if [[ -z "$STAGED_FILES" ]]; then
  echo "No files are staged for commit."
  return 1
fi

COMMIT_DIFF=$(git diff --cached origin/main)

# Generate PR title and body using AI
PROMPT=" SYSTEM: You are a helpful assistant that generates 
concise and informative pull request titles and descriptions 
based on a git diff. Provide your response in a structured 
format with a title (max 72 characters) and a body (using 
markdown formatting).  Highlight any areas that need to be 
edited by a human. Use the following structure:
TITLE: <title here>
BODY:
<body content here>


USER:
Generate a pull request title and body for the following diff:
$COMMIT_DIFF"

# Call the OpenAI API using the CLI
AI_CONTENT=$(ollama run deepseek-coder-v2 "$PROMPT" --keepalive 5m --verbose)

# Extract the title and body
PR_TITLE=$(echo "$AI_CONTENT" | sed -n 's/^TITLE: //p')
PR_BODY=$(echo "$AI_CONTENT" | sed -n '/^BODY:/,$p' | sed '1d')

# Truncate the title if it's too long
if [ ${#PR_TITLE} -gt 72 ]; then
  PR_TITLE="$\{PR_TITLE:0:69}..."
fi

# Display the generated title and body
echo
echo "Generated title:"
echo "-------------------------"
echo "$PR_TITLE"
echo "-------------------------"
echo
echo "Generated body:"
echo "-------------------------"
echo "$PR_BODY"
echo "-------------------------"
echo

# Ask user if they want to use the AI-generated content or enter their own
echo "Do you want to use this AI-generated title and body? (y/n)"
read -r -k1 USE_AI_CONTENT
echo

if [[ "$USE_AI_CONTENT" != "y" ]]; then
  echo "Enter a title for the pull request:"
  read -r PR_TITLE
  echo "Enter a body for the pull request (press Ctrl+D when finished):"
  PR_BODY=$(cat)
fi

# Create the pull request using GitHub CLI
if command -v gh &>/dev/null; then
  gh pr create --title "$PR_TITLE" --body "$PR_BODY"

  # Open the pull request in the browser
  gh pr view --web
else
  echo "GitHub CLI (gh) is not installed. Please install it to create pull requests automatically."
  echo "You can create a pull request manually at: https://github.com/$REPO_URL/pull/new/$CURRENT_BRANCH"
fi
