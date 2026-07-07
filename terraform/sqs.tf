# sqs.tf - Event buffering queue + Dead Letter Queue (DLQ)
# Collector pushes events to Queue; Analyzer consumes. Failed events go to DLQ.

# Dead Letter Queue - Receives failed processing events
resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-dlq"
  message_retention_seconds = 1209600 # Retain for 14 days for error investigation
}

# Main Queue - Buffers events between Collector and Analyzer
resource "aws_sqs_queue" "events" {
  name                       = "${var.project_name}-events"
  visibility_timeout_seconds = 300    # Should be >= timeout of Analyzer Lambda
  message_retention_seconds  = 345600 # Retain for 4 days

  # Move failed events to DLQ after 3 failed processing attempts
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}
