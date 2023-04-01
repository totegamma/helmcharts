{{/* Allow for S3 secret information to be stored in a Secret */}}
{{- define "postgres.s3" }}
[global]
repo1-s3-key={{ .accesskeyid }}
repo1-s3-key-secret={{ .secretaccesskey }}
{{ end }}
