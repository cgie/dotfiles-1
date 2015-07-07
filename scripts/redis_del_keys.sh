redis-cli keys "lock_*" | grep "lock_[a-z0-9]\+$" | xargs redis-cli DEL
redis-cli keys "polip*" | grep "polip" | xargs redis-cli DEL 
redis-cli keys "backe*" | grep "backe" | xargs redis-cli DEL 
