echo "redis: DEL bp_* ..." ; redis-cli keys "bp_*" | grep "bp" | xargs redis-cli DEL
echo "redis: DEL lock_* ..." ; redis-cli keys "lock_*" | grep "lock_[a-z0-9]\+$" | xargs redis-cli DEL
echo "redis: DEL polip* ..." ; redis-cli keys "polip*" | grep "polip" | xargs redis-cli DEL
echo "redis: DEL backe* ..." ; redis-cli keys "backe*" | grep "backe" | xargs redis-cli DEL
echo "redis: DEL gsp* ..." ; redis-cli keys "gsp*" | grep "gsp" | xargs redis-cli DEL
