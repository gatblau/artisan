PROJECT_GROUP_ID=$1
PROJECT_ARTIFACT_ID=$2
mvn io.quarkus:quarkus-maven-plugin:1.11.1.Final:create -DprojectGroupId=${PROJECT_GROUP_ID} -DprojectArtifactId=${PROJECT_ARTIFACT_ID} -DprojectVersion=0.0.1
cp -r ${PROJECT_ARTIFACT_ID}/. .
rm -R ${PROJECT_ARTIFACT_ID}
cp src/main/docker/Dockerfile.jvm _build/image/Dockerfile
art build -t registry/${PROJECT_GROUP_ID}/${PROJECT_ARTIFACT_ID} -p image
art flow merge _build/flows/s2p_bare.yaml
art tkn gen _build/flows/s2p.yaml > _build/flows/s2p_tkn.yaml