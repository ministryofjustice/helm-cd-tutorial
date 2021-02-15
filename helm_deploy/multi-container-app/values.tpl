# Default values for multi-container-app.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

databaseUrlSecretName: rds-instance-output
contentapiurl: "http://content-api-service:4567/image_url.json"

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: helm-cd.apps.live-1.cloud-platform.service.justice.gov.uk
      paths: []
  # Update tls for custom domain and update secretName where certificate is stored
  # tls:
  #   - secretName: <CERTIFICATE-SECRET-NAME>
  #     hosts:
  #       - <DNS-PREFIX>.apps.live-1.cloud-platform.service.justice.gov.uk

postgresql:
  enabled: true
  existingSecret: container-postgres-secrets
  postgresqlDatabase: multi_container_demo_app
  persistence:
    enabled: false

contentapi:
  replicaCount: 1
  image:
    repository: 754256621582.dkr.ecr.eu-west-2.amazonaws.com/${ECR_NAME}
    tag: content-api-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 4567
    targetPort: 4567

railsapp:
  replicaCount: 1
  image:
    repository: 754256621582.dkr.ecr.eu-west-2.amazonaws.com/${ECR_NAME}
    tag: rails-app-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 3000
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 3000
    targetPort: 3000
  job:
    backoffLimit: 4
    restartPolicy: OnFailure

worker:
  replicaCount: 1
  image:
    repository: 754256621582.dkr.ecr.eu-west-2.amazonaws.com/${ECR_NAME}
    tag: worker-${GITHUB_SHA}
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
