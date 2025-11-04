# Redis Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Data Types](#data-types)
- [Keys Management](#keys-management)
- [String Operations](#string-operations)
- [Hash Operations](#hash-operations)
- [List Operations](#list-operations)
- [Set Operations](#set-operations)
- [Sorted Set Operations](#sorted-set-operations)
- [HyperLogLogs](#hyperloglogs)
- [Bitmaps](#bitmaps)
- [Streams](#streams)
- [Transactions](#transactions)
- [Lua Scripting](#lua-scripting)
- [Pub/Sub](#pubsub)
- [Persistence](#persistence)
- [Replication](#replication)
- [Cluster](#cluster)
- [Security](#security)
- [Performance Tips](#performance-tips)
- [Useful CLI Commands](#useful-cli-commands)
- [References](#references)

## Introduction
Redis is an in-memory data structure store, used as a database, cache, and message broker.

## Installation
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install redis-server

# MacOS
brew install redis

# Start Redis server
redis-server
```

## Basic Commands
```bash
redis-cli                 # Start the Redis CLI
ping                      # Check server connection
select <db>               # Select database (default 0)
flushall                  # Delete all keys from all databases
flushdb                   # Delete all keys from the current database
```

## Data Types
- Strings
- Hashes
- Lists
- Sets
- Sorted Sets
- Bitmaps
- HyperLogLogs
- Streams

## Keys Management
```bash
keys *                    # List all keys
exists <key>              # Check if a key exists
del <key>                 # Delete a key
type <key>                # Get the data type of a key
expire <key> <seconds>    # Set a timeout on a key
ttl <key>                 # Get remaining time to live
rename <key> <newkey>     # Rename a key
move <key> <db>           # Move key to another database
```

## String Operations
```bash
set key value             # Set a value
get key                   # Get a value
incr key                  # Increment a value
decr key                  # Decrement a value
append key value          # Append a value
mget key1 key2 ...        # Get multiple values
mset key1 val1 key2 val2  # Set multiple key-value pairs
strlen key                # Get the length of a string value
```

## Hash Operations
```bash
hset key field value      # Set a field
hget key field            # Get a field value
hdel key field            # Delete a field
hgetall key               # Get all fields and values
hmset key field1 val1 field2 val2  # Set multiple fields
hmget key field1 field2   # Get multiple fields
hlen key                  # Get number of fields
```

## List Operations
```bash
lpush key value           # Prepend a value to a list
rpush key value           # Append a value to a list
lpop key                  # Remove and get first element
rpop key                  # Remove and get last element
lrange key start stop     # Get elements within a range
llen key                  # Get length of list
lindex key index          # Get an element by index
lset key index value      # Set list element by index
```

## Set Operations
```bash
sadd key member           # Add a member to set
srem key member           # Remove a member from set
smembers key              # Get all members
sismember key member      # Check if member exists
sunion key1 key2          # Union of sets
sinter key1 key2          # Intersection of sets
sdiff key1 key2           # Difference of sets
scard key                 # Get number of members
```

## Sorted Set Operations
```bash
zadd key score member     # Add a member with a score
zrange key start stop     # Get members by rank
zrevrange key start stop  # Get members by reverse rank
zrem key member           # Remove a member
zscore key member         # Get score of member
zrank key member          # Get rank of member
zrangebyscore key min max # Get members within score range
```

## HyperLogLogs
```bash
pfadd key element1 element2  # Add elements to HyperLogLog
pfcount key                  # Count unique elements (approximate)
pfmerge destkey sourcekey1 sourcekey2  # Merge HyperLogLogs
```

## Bitmaps
```bash
setbit key offset value       # Set or clear a bit
getbit key offset             # Get bit value at offset
bitcount key                  # Count set bits
bitop operation destkey key1 key2  # Perform bitwise operations
```

## Streams
```bash
xadd mystream * field1 value1  # Add entry to stream
xread streams mystream 0       # Read entries from stream
xrange mystream - +            # Get entries within range
xdel mystream id               # Delete entry by ID
```

## Transactions
```bash
multi                     # Start transaction
commands...               # Queue commands
exec                      # Execute queued commands
discard                   # Discard queued commands
watch key                 # Watch a key for conditional transaction
unwatch                   # Unwatch all keys
```

## Lua Scripting
```bash
eval "return redis.call('set', KEYS[1], ARGV[1])" 1 mykey myvalue  # Set using Lua
```

## Pub/Sub
```bash
publish channel message   # Publish a message
subscribe channel         # Subscribe to a channel
unsubscribe channel       # Unsubscribe from a channel
psubscribe pattern        # Subscribe to channels by pattern
punsubscribe pattern      # Unsubscribe from pattern
```

## Persistence
- **RDB**: Point-in-time snapshots.
- **AOF**: Append-only file for all operations.

```bash
save                      # Create a snapshot (RDB)
bgsave                    # Create snapshot in background
bgrewriteaof              # Rebuild AOF file
```

## Replication
```bash
replicaof <master-ip> <master-port>   # Configure replica
info replication                      # Monitor replication
```

## Cluster
- Shard data across multiple Redis nodes.
- Achieve high availability with Redis Sentinel or native clustering.

```bash
cluster info                   # View cluster information
cluster nodes                  # List cluster nodes
cluster meet ip port            # Add node to cluster
```

## Security
```bash
requirepass yourpassword        # Password authentication
rename-command FLUSHDB ""        # Disable dangerous commands
protected-mode yes              # Protect open access
```

## Performance Tips
- Use pipelines to batch commands.
- Set reasonable expiration for keys.
- Use appropriate data structures.
- Avoid huge keys or values.
- Monitor performance with `MONITOR`, `INFO`, `SLOWLOG`.
- Use `SCAN` instead of `KEYS` in production.

## Useful CLI Commands
```bash
info memory                     # View memory usage
info stats                      # View server stats
slowlog get                     # Get slow query logs
monitor                         # Monitor real-time commands
config get *                    # View current configuration
```

## References
- [Redis Official Documentation](https://redis.io/docs/)
- [Redis GitHub Repository](https://github.com/redis/redis)

