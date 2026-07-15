
# Alarm 1: Lambda Collector lỗi
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
    alarm_name = "${var.project_name}-collector-errors"
    alarm_description = "Alarm when Lambda Collector encounters an error"
    namespace = "AWS/Lambda"
    metric_name = "Errors"
    statistic = "Sum"
    comparison_operator = "GreaterThanThreshold"
    threshold = 0
    period = 300 # 5 phut
    evaluation_periods = 1
    treat_missing_data = "notBreaching"

    dimensions = {
        FunctionName = aws_lambda_function.collector.function_name
    }

    alarm_actions = [aws_sns_topic.cost_alerts.arn]
    ok_actions = [aws_sns_topic.cost_alerts.arn]
}

# Alarm 2: Lambda Analyzer lỗi
resource "aws_cloudwatch_metric_alarm" "analyzer_errors" {
    alarm_name = "${var.project_name}-analyzer-errors"
    alarm_description = "Alarm when Lambda Analyzer encounters an error"
    namespace = "AWS/Lambda"
    metric_name = "Errors"
    statistic = "Sum"
    comparison_operator = "GreaterThanThreshold"
    threshold = 0
    period = 300 # 5 minutes
    evaluation_periods = 1
    treat_missing_data  = "notBreaching"

    dimensions = {
        FunctionName = aws_lambda_function.analyzer.function_name
    }

    alarm_actions = [aws_sns_topic.cost_alerts.arn]
    ok_actions = [aws_sns_topic.cost_alerts.arn]
}

# Alarm 3: Message DLQ
resource "aws_cloudwatch_metric_alarm" "dlq_message" {
    alarm_name = "${var.project_name}-dlq-has-messages"
    alarm_description = "Alarm when DLQ has messages"
    namespace = "AWS/SQS"
    metric_name = "ApproximateNumberOfMessagesVisible"
    statistic = "Maximum"
    comparison_operator = "GreaterThanThreshold"
    threshold = 0
    period = 300
    evaluation_periods = 1
    treat_missing_data = "notBreaching"

    dimensions = {
        QueueName = aws_sqs_queue.dlq.name
    }

    alarm_actions = [aws_sns_topic.cost_alerts.arn]
    ok_actions = [aws_sns_topic.cost_alerts.arn]
}
