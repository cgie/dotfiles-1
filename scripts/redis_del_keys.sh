redis-cli keys "lock_*" | grep "lock_[a-z0-9]\+$" | xargs redis-cli DEL
