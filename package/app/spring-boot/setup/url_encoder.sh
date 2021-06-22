#!/bin/sh
#url encoding to handle git password special characters

url_var() {
   LC_ALL=C
   ___encoded=""
   ___temp="$( mktemp )"
   # needs GNU head
   echo "${1}" | sed -r -e 's/(.)/\1\n/g;' | head -n -1 | while read char ;
   do
      #echo "Char: ${char}"
      test '\0' != "${char}" &&
      case "${char}" in
         [a-zA-Z0-9/_.~-] ) ___encoded="${___encoded}${char}" ; test -n "${DEBUG}" && echo "Found simple \"${char}\"" 1>&2 ;;
         * ) ___encoded="${___encoded}$( $( which printf ) "%%%02x" "'${char}" )" ;;
      esac
      echo "${___encoded}" > "${___temp}"
   done
   ___encoded="$( cat "${___temp}" )" ; rm -f "${___temp}"
   export GIT_REPO_PWD="${___encoded}"
}

url_var "${1}"