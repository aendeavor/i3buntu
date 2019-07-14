DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RES="$( readlink -m "${DIR}/../resources" )"
BACK="$(readlink -m "${DIR}/../backups/$(date '+%d-%m-%Y--%H:%M')")"
LOG="${BACK}/.install_log"    

echo $DIR
echo $RES
echo $BACK
echo $LOG