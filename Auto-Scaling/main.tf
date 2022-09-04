resource "aws_launch_configuration" "aws_autoscale_conf" {
    name = "dva_web_config"

    image_id = var.ami

    instance_type = var.instance_type
}

resource "aws_autoscaling_group" "my_as_group" {
  availability_zones = [ "us-east-2a" ]
  name = "autoscalegroup"
  max_size = 2
  min_size = 1
  health_check_grace_period = 30
  health_check_type = "EC2"
  force_delete = true
  termination_policies = ["OldestInstance"]
  launch_configuration = aws_launch_configuration.aws_autoscale_conf.name
}

resource "aws_autoscaling_schedule" "mygroup_schedule" {
    scheduled_action_name = "autoscalegroup_action"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    start_time = "2022-09-09T18:00:00Z"
    autoscaling_group_name = aws_autoscaling_group.my_as_group.name
}

resource "aws_autoscaling_policy" "mygroup_policy" {
  name = "autoscalegroup_policy"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.my_as_group.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "10"
  alarm_actions = [
    "${aws_autoscaling_policy.mygroup_policy.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.my_as_group.name}"
  }
}