let
  wuz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGA16AOM7pIZFc+QK9GSWYc7WKsv9A90mzfer9iJF0F6";
in
{
  "github-access-token.age".publicKeys = [ wuz ];
}
