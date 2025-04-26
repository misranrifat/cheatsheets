# MongoDB Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic CLI Operations](#basic-cli-operations)
- [CRUD Operations](#crud-operations)
- [Aggregation Framework](#aggregation-framework)
- [Indexing](#indexing)
- [Data Modeling Tips](#data-modeling-tips)
- [Backup and Restore](#backup-and-restore)
- [Replica Sets Basics](#replica-sets-basics)
- [Sharding Basics](#sharding-basics)
- [Transactions](#transactions)
- [Schema Validation](#schema-validation)
- [MongoDB Atlas](#mongodb-atlas)
- [Monitoring and Performance Tuning](#monitoring-and-performance-tuning)
- [Security Best Practices](#security-best-practices)
- [References](#references)

## Introduction
MongoDB is a NoSQL database that stores data in flexible, JSON-like documents, enabling fast and flexible development.

## Installation
```bash
# Ubuntu
sudo apt update
sudo apt install -y mongodb

# MacOS
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community
```

## Basic CLI Operations
```bash
mongo                          # Start Mongo Shell
mongosh                        # New MongoDB Shell
show dbs                       # List all databases
use <database>                 # Switch database
show collections               # List collections
exit                           # Exit shell
```

## CRUD Operations

### Create
```javascript
db.collection.insertOne({ name: "Alice", age: 25 })
db.collection.insertMany([{ name: "Bob" }, { name: "Charlie" }])
```

### Read
```javascript
db.collection.find({})                         // Find all

// Find with query and projection
db.collection.find({ name: "Alice" }, { _id: 0, name: 1 })

// Find one document
db.collection.findOne({ name: "Alice" })
```

### Update
```javascript
db.collection.updateOne({ name: "Alice" }, { $set: { age: 26 } })
db.collection.updateMany({ age: { $lt: 30 } }, { $inc: { age: 1 } })

// Replace document
db.collection.replaceOne({ name: "Alice" }, { name: "Alice", city: "NY" })
```

### Delete
```javascript
db.collection.deleteOne({ name: "Bob" })
db.collection.deleteMany({ age: { $gte: 30 } })
```

## Aggregation Framework

### Basic Aggregation
```javascript
db.collection.aggregate([
  { $match: { age: { $gte: 25 } } },
  { $group: { _id: "$name", totalAge: { $sum: "$age" } } },
  { $sort: { totalAge: -1 } }
])
```

### Common Aggregation Stages
- `$match` - Filter documents
- `$group` - Group documents
- `$project` - Transform shape of documents
- `$sort` - Sort documents
- `$limit`, `$skip` - Paginate results
- `$lookup` - Perform join between collections
- `$unwind` - Deconstruct array fields
- `$count` - Count documents

### Lookup Example (Join)
```javascript
db.orders.aggregate([
  { $lookup: {
      from: "products",
      localField: "productId",
      foreignField: "_id",
      as: "productInfo"
    }
  }
])
```

## Indexing

### Create Index
```javascript
db.collection.createIndex({ name: 1 })        // Ascending index
```

### Compound Index
```javascript
db.collection.createIndex({ name: 1, age: -1 })
```

### Text Index
```javascript
db.collection.createIndex({ name: "text", description: "text" })
```

### Geospatial Index
```javascript
db.collection.createIndex({ location: "2dsphere" })
```

### View Indexes
```javascript
db.collection.getIndexes()
```

### Drop Index
```javascript
db.collection.dropIndex("index_name")
```

## Data Modeling Tips
- Embed related data when access patterns require.
- Normalize if there is large duplication.
- Design according to queries, not relations.
- Avoid large documents (>16MB limit).
- Pre-aggregate data where appropriate.
- Avoid growing arrays indefinitely.

## Backup and Restore
```bash
# Backup database
mongodump --db <dbname> --out /backup/path

# Backup specific collection
mongodump --db <dbname> --collection <collname> --out /backup/path

# Restore full database
mongorestore /backup/path/<dbname>

# Restore specific collection
mongorestore --db <dbname> --collection <collname> /backup/path/<dbname>/<collname>.bson
```

## Replica Sets Basics

### Create Replica Set
```bash
mongod --replSet "rs0"
```

### Initialize Replica Set
```javascript
rs.initiate()
```

### Add Members
```javascript
rs.add("hostname:port")
```

### Replica Set Status
```javascript
rs.status()
```

## Sharding Basics

### Components
- **Shard**: Data holder
- **Config Servers**: Metadata holder
- **Mongos Router**: Query router

### Enable Sharding
```javascript
sh.enableSharding("myDatabase")
sh.shardCollection("myDatabase.myCollection", { shardKey: 1 })
```

### Check Shard Status
```javascript
sh.status()
```

## Transactions
- Multi-document transactions (MongoDB 4.0+)

### Start Transaction
```javascript
session = db.getMongo().startSession()
collection = session.getDatabase("test").collection("items")

session.startTransaction()
collection.insertOne({ name: "item1" })
collection.insertOne({ name: "item2" })
session.commitTransaction()
```

## Schema Validation

### Add Validation Rules
```javascript
db.createCollection("people", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "age"],
      properties: {
        name: {
          bsonType: "string",
          description: "must be a string and is required"
        },
        age: {
          bsonType: "int",
          minimum: 0,
          description: "must be an integer greater than or equal to 0"
        }
      }
    }
  }
})
```

## MongoDB Atlas
- Fully managed cloud MongoDB service.
- Built-in backups, scaling, monitoring.
- Easy replica sets, sharding, VPC peering.

```bash
# Connect from local
mongo "mongodb+srv://cluster0.mongodb.net/test" --username user
```

## Monitoring and Performance Tuning

### Monitor Commands
```javascript
serverStatus()                // Detailed server statistics
currentOp()                   // Currently running operations
dbStats()                     // Stats for a database
collStats("collection")        // Stats for a collection
```

### Performance Tips
- Create indexes based on query patterns.
- Avoid using `$where` unless necessary.
- Minimize document size.
- Use connection pooling for drivers.
- Monitor slow queries with `system.profile`.

## Security Best Practices
- Enable authentication (`mongod --auth`).
- Use TLS/SSL for encryption.
- Restrict network exposure.
- Enable Role-Based Access Control (RBAC).
- Regularly rotate credentials.
- Enable auditing if needed.

## References
- [MongoDB Official Documentation](https://www.mongodb.com/docs/)
- [MongoDB Aggregation Framework](https://www.mongodb.com/docs/manual/aggregation/)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- [MongoDB Security Manual](https://www.mongodb.com/docs/manual/administration/security/)

