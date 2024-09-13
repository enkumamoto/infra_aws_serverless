## Lambda loader function
resource "aws_lambda_function" "lambda_loader" {
  function_name = "BlackstoneLoader"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Raw Tags Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.loader-function.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }
  tags = {
    Name        = "BlackstoneLoader"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_loader_arn" {
  value = aws_lambda_function.lambda_loader.arn
}

## Lambda Loader Trigger
resource "aws_lambda_event_source_mapping" "lambda_loader_trigger" {
  event_source_arn = aws_sqs_queue.sqs.arn
  function_name    = aws_lambda_function.lambda_loader.arn
  depends_on       = [aws_sqs_queue.sqs]
}

## Lambda Modules function
resource "aws_lambda_function" "lambda_duplicated_tags" {
  function_name = "DuplicatedTags"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Module Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDuplicatedTags"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_duplicated_tags_arn" {
  value = aws_lambda_function.lambda_duplicated_tags.arn
}

## Lambda Common Monitor function
resource "aws_lambda_function" "lambda_component_surveillance" {
  function_name = "ComponentSurveillance"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneComponentSurveillance"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_component_surveillance_arn" {
  value = aws_lambda_function.lambda_component_surveillance.arn
}

## Lambda Common Monitor function
resource "aws_lambda_function" "lambda_data_collection_frequency" {
  function_name = "DataCollectionFrequency"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataCollectionFrequency"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_data_collection_frequency_arn" {
  value = aws_lambda_function.lambda_data_collection_frequency.arn
}

## Lambda Data Quality function
resource "aws_lambda_function" "lambda_dataquality" {
  function_name = "DataQuality"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.dataquality-function.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataQuality"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_dataquality_arn" {
  value = aws_lambda_function.lambda_dataquality.arn
}

# Lambda Monitor function
resource "aws_lambda_function" "lambda_monitor_function" {
  function_name = "BlackstoneMonitor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.monitor-function.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_monitor_function_arn" {
  value = aws_lambda_function.lambda_monitor_function.arn
}

## Lambda Tag State function
resource "aws_lambda_function" "lambda_tag_state_function" {
  function_name = "TagState"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.tagstate-function.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneTagState"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_tag_state_function_arn" {
  value = aws_lambda_function.lambda_tag_state_function.arn
}

## Lambda Metadata Merger function
resource "aws_lambda_function" "lambda_metadata_merger_function" {
  function_name = "BlackstoneMetadataMerger"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneMetadataMerger"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_metadata_merger_function_arn" {
  value = aws_lambda_function.lambda_metadata_merger_function.arn
}

## Lambda Data Work Flow function
resource "aws_lambda_function" "lambda_data_work_flow_function" {
  function_name = "DataWorkflow"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataWorkflow"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_data_work_flow_function_arn" {
  value = aws_lambda_function.lambda_data_work_flow_function.arn
}

# Lambda Tag Config Consistency function
resource "aws_lambda_function" "lambda_tag_config_consistency_function" {
  function_name = "TagConfigConsistency"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # definir a imagem da lambda
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneTagConfigConsistency"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_tag_config_consistency_function_arn" {
  value = aws_lambda_function.lambda_tag_config_consistency_function.arn
}
