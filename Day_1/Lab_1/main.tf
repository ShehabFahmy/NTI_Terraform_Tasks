resource "local_file" "hello-file" {
	content = "Hello NTI!"
	filename = "hello.txt"
}