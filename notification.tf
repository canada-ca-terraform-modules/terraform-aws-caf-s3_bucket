# Event notifications to Lambda, SQS, SNS, or EventBridge.

resource "aws_s3_bucket_notification" "this" {
  for_each = try(var.bucket.notification, null) != null ? { enabled = true } : {}

  bucket      = aws_s3_bucket.this.id
  eventbridge = try(var.bucket.notification.eventbridge, null)

  dynamic "lambda_function" {
    for_each = try(var.bucket.notification.lambda_function, [])
    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }

  dynamic "queue" {
    for_each = try(var.bucket.notification.queue, [])
    content {
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = try(queue.value.filter_prefix, null)
      filter_suffix = try(queue.value.filter_suffix, null)
    }
  }

  dynamic "topic" {
    for_each = try(var.bucket.notification.topic, [])
    content {
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = try(topic.value.filter_prefix, null)
      filter_suffix = try(topic.value.filter_suffix, null)
    }
  }
}
