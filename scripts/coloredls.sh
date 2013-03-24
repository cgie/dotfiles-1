#/bin/sh

ls -l | awk '
/^d/{printf "\033[34m%s\033[0m\n",$0;next}
/^l/{printf "\033[35m%s\033[0m\n",$0;next}
$1~"x"{printf "\033[36m%s\033[0m\n",$0;next}
{print}'