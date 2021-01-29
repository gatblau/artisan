if [[ -z "${SONAR_PROJECT_KEY+x}" ]]; then
    echo "SONAR_PROJECT_KEY must be provided"
    exit 1
fi

if [[ -z "${SONAR_URI+x}" ]]; then
    echo "SONAR_URI must be provided"
    exit 1
fi

if [[ -z "${SONAR_SOURCES+x}" ]]; then
    echo "SONAR_SOURCES must be provided"
    exit 1
fi

if [[ -z "${SONAR_BINARIES+x}" ]]; then
    echo "SONAR_BINARIES must be provided"
    exit 1
fi

if [[ -z "${SONAR_TOKEN+x}" ]]; then
    echo "SONAR_TOKEN must be provided"
    exit 1
fi

# merge sonar URI variable
printf "sonar.sourceEncoding=UTF-8\nsonar.host.url=%s\n" "${SONAR_URI}" > /sonar/conf/sonar-scanner.properties

# take the start time for the scanning process
START_TIME=$(date +"%Y-%m-%dT%T+0000")

# initiates the scan process
sonar-scanner -Dsonar.projectKey="${SONAR_PROJECT_KEY}" -Dsonar.sources="${SONAR_SOURCES}" -Dsonar.java.binaries="${SONAR_BINARIES}" -Dsonar.login="${SONAR_TOKEN}"

# if the exit code of the previous command is not zero
if [ "$?" -ne 0 ]; then
    printf "failed to run the Sonar scanner\n"
    exit 1
fi

printf "sonar server is %s\n" "${SONAR_URI}"
printf "project key is %s\n" "${SONAR_PROJECT_KEY}"
printf "waiting for analysis to complete"

# query sonar API until the uploaded report has been analysed
art wait -f "$.analyses[?(@.date>'${START_TIME}')].date" -a 20 "${SONAR_URI}/api/project_analyses/search?project=${SONAR_PROJECT_KEY}"
