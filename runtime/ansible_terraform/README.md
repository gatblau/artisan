# ansible_terraform Artisan runtime
This is a specific image for an edge case where:
1. The image needs to be as small as possible (hence Alpine not ubi-min)
2. Both Terraform and Ansible installed in the same image (again to cut down on download requirements)
3. Allow UID/GID to be over-ridden if required