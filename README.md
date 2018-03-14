# Pooly

**A worker pool application (Inspired by Poolboy library)**

| Version | Characteristics          |
| :-----: | -------------------------|
|   |                                |
|   | Supports a single pool. |
| 1 | Supports a fixed number of workers. |
|   | No recovery when consumer and/or worker process fail  |
|   |                                |
|   | Supports a single pool. |
| 2 | Supports a fixed number of workers. |
|   | Recovery when consumer and/or worker process fail. |
|   |                                |
| 3 | Supports multiple pools. |
|   | Supports a variable number of workers |
|   |                                |
|   | Supports multiple pools. |
| 4 | Variable-sized pool allows for worker overflow. |
|   | Queuing for consumer processes when all workers are busy |
