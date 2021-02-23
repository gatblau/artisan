#Store git Credentials
cat > ${HOME}/.netrc <<EOF

machine $1
login $2
password $3
protocol https

EOF