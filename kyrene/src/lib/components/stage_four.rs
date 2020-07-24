// #!/usr/bin/env bash

// function check_code() {
// 	if [ -z "$(command -v code)" ] && [ ! -e "/snap/bin/code" ]; then
// 	    err 'VS Code is not installed. Aborting the installation of extensions'
// 	    exit 1
// 	fi

// 	CODE=$(command -v code); [ -z "${CODE}" ] && CODE="/snap/bin/code"
// 	INSTALL=( "${CODE}" --install-extension )
// }

// function install_extensions() {
// 	printf "%-40s | %-15s | %-15s" "EXTENSION" "STATUS" "EXIT CODE"
//     echo ''

// 	for EXTENSION in "${EXT[@]}"; do
// 		&>>/dev/null "${INSTALL[@]}" "${EXTENSION}"

// 		EC=$?
// 		if (( EC != 0 )); then
// 			printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Not Installed" "${EC}"
// 		else
// 			printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Installed" "${EC}"
// 		fi
		
//         echo ''
// 	done
// }
