# AWS Cloudwatch

- Amazon CloudWatch monitors your Amazon Web Services (AWS) resources and the applications you run on AWS in real time. You can use CloudWatch to collect and track metrics, which are variables you can measure for your resources and applications.

## How Cloudwatch works

![alt text](services/cloudwatch/CW-Overview.png)

- Amazon CloudWatch is basically a metrics repository
- An AWS service—such as Amazon EC2—puts metrics into the repository, and you retrieve statistics based on those metrics
- You can use metrics to calculate statistics and then present the data graphically in the CloudWatch console.
- CloudWatch provides two categories of monitoring: basic monitoring and detailed monitoring.
- Detailed monitoring is offered by only some services. It also incurs charges.
- In different AWS services, detailed monitoring also has different names. For example, in Amazon EC2 it is called detailed monitoring, in AWS Elastic Beanstalk it is called enhanced monitoring, and in Amazon S3 it is called request metrics.
- You can configure alarm actions to stop, start, or terminate an Amazon EC2 instance when certain criteria are met
- [Services that publish Cloudwatch metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html)
- Metrics are stored separately in Regions, but you can use CloudWatch cross-Region functionality to aggregate statistics from different Regions


| Topic         | Details     | Example |
|--------------|-----------|------------|
| Namespaces | A namespace is a container for CloudWatch metrics      | AWS/EC2        |
| Metrics    | A metric represents a time-ordered set of data points that are published to CloudWatch  | the CPU usage of a particular EC2 instance       |
| Dimensions | 1.99      | *7*        |
| Resolution    | **1.89**  | 5234       |
| Statistics | 1.99      | *7*        |
| Percentiles    | **1.89**  | 5234       |
| Alarms | 1.99      | *7*        |



## Metrics

- By default, many AWS services provide metrics at **no charge for resources** 
- For a charge, you can also enable **detailed monitoring for some resources**, such as your Amazon EC2 instances, or publish your own application metrics. 
- For custom metrics, you can add the data points in any order, and at any rate you choose. You can retrieve statistics about those data points as an ordered set of time-series data.
- Metrics are uniquely defined by a name, a namespace, and zero or more dimensions. 
- Each data point in a metric has a time stamp, and (optionally) a unit of measure. 
- You can retrieve statistics from CloudWatch for any metric.
- [Availabile Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/viewing_metrics_with_cloudwatch.html)


- **Important Note**
  - Metrics that have not had any new data points in the past two weeks do not appear in the console. They also do not appear when you type their metric name or dimension names in the search box in the All metrics tab in the console, and they are not returned in the results of a list-metrics command.
  - Metrics cannot be deleted, but they automatically expire after 15 months if no new data is published to them.
  - Data points older than 15 months expire on a rolling basis; as new data points come in, data older than 15 months is dropped.
  - Metrics exist only in the Region in which they are created. 


### Important commands

1. List metrics
```bash
aws cloudwatch list-metrics --namespace AWS/EC2
```

2. List all metrics for a specified resource

```bash
aws cloudwatch list-metrics --namespace AWS/EC2 --dimensions Name=InstanceId,Value=i-0fb16c73513fac0e6
```
3. List all metrics for all resources

```bash
aws cloudwatch list-metrics --namespace AWS/EC2 --metric-name CPUUtilization
```
```json
{
    "Metrics": [
        {
            "Namespace": "AWS/EC2",
            "MetricName": "CPUUtilization",
            "Dimensions": [
                {
                    "Name": "InstanceId",
                    "Value": "i-0fb16c73513fac0e6"
                }
            ]
        }
    ]
}
```

   
4. Getting metrics from all the linked accounts

```bash
aws cloudwatch list-metrics --include-linked-accounts
```

5. To retrieve a metric from source account for cross account observability

```bash
aws cloudwatch list-metrics --include-linked-accounts --owning-account "111122223333"
```

### Metrics retention
    
- Data points with a period of less than 60 seconds are available for 3 hours. These data points are high-resolution custom metrics.
- Data points with a period of 60 seconds (1 minute) are available for 15 days
- Data points with a period of 300 seconds (5 minutes) are available for 63 days
- Data points with a period of 3600 seconds (1 hour) are available for 455 days (15 months)

- **Important** - Data points that are initially published with a shorter period are aggregated together for long-term storage. For example, if you collect data using a period of 1 minute, the data remains available for 15 days with 1-minute resolution. After 15 days this data is still available, but is aggregated and is retrievable only with a resolution of 5 minutes. After 63 days, the data is further aggregated and is available with a resolution of 1 hour. 

## Timestamps

- Each metric data point must be associated with a time stamp. 
- The time stamp can be up to two weeks in the past and up to two hours into the future.
-  If you do not provide a time stamp, CloudWatch creates a time stamp for you based on the time the data point was received. 
- CloudWatch alarms check metrics based on the current time in UTC.
- Custom metrics sent to CloudWatch with time stamps other than the current UTC time can cause alarms to display the Insufficient Data state or result in delayed alarms.


## Dimensions

- A dimension is a name/value pair that is part of the identity of a metric. You can assign up to 30 dimensions to a metric.
- Every metric has specific characteristics that describe it, and you can think of dimensions as categories for those characteristics. 
- Dimensions help you design a structure for your statistics plan.


## Resolution

Each metric is one of the following:

- Standard resolution, with data having a one-minute granularity
- High resolution, with data at a granularity of one second
- High-resolution metrics can give you more immediate insight into your application's sub-minute activity. 
- Keep in mind that every `PutMetricData` call for a custom metric is charged, so calling `PutMetricData` more often on a high-resolution metric can lead to higher charges.


## Statistics

- Statistics are metric data aggregations over specified periods of time. 
- Aggregations are made using the namespace, metric name, dimensions, and the data point unit of measure, within the time period you specify.


## Units

- Each statistic has a unit of measure. 
- Example units include Bytes, Seconds, Count, and Percent. 
- You can specify a unit when you create a custom metric. 
- Metric data points that specify a unit of measure are aggregated separately. 
- When you get statistics without specifying a unit, CloudWatch aggregates all data points of the same unit together. 
- If you have two otherwise identical metrics with different units, two separate data streams are returned, one for each unit.

## Periods

- A period is the length of time associated with a specific Amazon CloudWatch statistic. - Each statistic represents an aggregation of the metrics data collected for a specified period of time. 
- Periods are defined in numbers of seconds, and valid values for period are 1, 5, 10, 30, or any multiple of 60. 
- For example, to specify a period of six minutes, use 360 as the period value. 
- You can adjust how the data is aggregated by varying the length of the period. 
- The default value of a period is 60 seconds. 
- A period can be as short as one second, and must be a multiple of 60 if it is greater than the default value of 60 seconds. 

## Aggregation

- Amazon CloudWatch aggregates statistics according to the period length that you specify when retrieving statistics. 
- You can publish as many data points as you want with the same or similar time stamps
- CloudWatch aggregates them according to the specified period length. 
- CloudWatch does not automatically aggregate data across Regions, but you can use metric math to aggregate metrics from different Regions.


## Percentiles

- A percentile indicates the relative standing of a value in a dataset.
-  For example, the 95th percentile means that 95 percent of the data is lower than this value and 5 percent of the data is higher than this value. 
- Percentiles help you get a better understanding of the distribution of your metric data.


## Alarms

- You can use an alarm to automatically initiate actions on your behalf. 
- An alarm watches a single metric over a specified time period, and performs one or more specified actions, based on the value of the metric relative to a threshold over time. - - The action is a notification sent to an Amazon SNS topic or an Auto Scaling policy. You can also add alarms to dashboards.
- Alarms invoke actions for sustained state changes only. 
- CloudWatch alarms do not invoke actions simply because they are in a particular state. The state must have changed and been maintained for a specified number of periods.


## Cloudwatch billing and costs


## Cloudwatch dashboards

- All dashboards are global
- You can use the `PutDashboard` API operation to create a dashboard from the command line interface. 
- Amazon CloudWatch dashboards are customizable home pages in the CloudWatch console that you can use to monitor your resources in a single view, even those resources that are spread across different Regions. 
- To access CloudWatch dashboards, you need one of the following:
  - The `AdministratorAccess` policy
  - The `CloudWatchFullAccess` policy
  - A custom policy that includes one or more of these specific permissions:
     - cloudwatch:GetDashboard and cloudwatch:ListDashboards to be able to view dashboards
     - cloudwatch:PutDashboard to be able to create or modify dashboards
     - cloudwatch:DeleteDashboards to be able to delete dashboards


## CloudWatch Metrics Insights

- CloudWatch Metrics Insights is a powerful high-performance SQL query engine that you can use to query your metrics at scale. 
- You can identify trends and patterns within all of your CloudWatch metrics in real time.
- You can also set alarms on any Metrics Insights queries that return a single time series.


## Custom setup with Amazon Firehose


- Create a metric stream and direct it to an Amazon Data Firehose delivery stream that delivers your CloudWatch metrics to where you want them to go. You can stream them to a data lake such as Amazon S3, or to any destination or endpoint supported by Firehose including third-party providers. JSON, OpenTelemetry 1.0.0, and OpenTelemetry 0.7.0 formats are supported natively, or you can configure transformations in your Firehose delivery stream to convert the data to a different format such as Parquet. With a metric stream, you can continually update monitoring data, or combine this CloudWatch metric data with billing and performance data to create rich datasets. You can then use tools such as Amazon Athena to get insight into cost optimization, resource performance, and resource utilization.

- oudWatch provides a quick setup experience for some third-party partners. You can use third-party service providers to monitor, troubleshoot, and analyze your applications using the streamed CloudWatch data. When you use the quick partner setup workflow, you need to provide only a destination URL and API key for your destination, and CloudWatch handles the rest of the setup. Quick partner setup is available for the following third-party providers:

 - Datadog
 - Dynatrace
 - New Relic
 - Splunk Observability Cloud
 - SumoLogic


 ## Cloudwatch anomaly detection

 