# API Service

| Category     | SLI | SLO                                                                                                         |
|--------------|-----|-------------------------------------------------------------------------------------------------------------|
| Availability | (total number of up time/ total number of total time) >= 99% | 99%                                                                                                         |
| Latency      | p90 of request latency less than 100ms | 90% of requests below 100ms                                                                                 |
| Error Budget | in 1 week, ( total number of errors/total number of requests) < 20%| Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget |
| Throughput   | total of successful requests per second >= 5 | 5 RPS indicates the application is functioning                                                              |
