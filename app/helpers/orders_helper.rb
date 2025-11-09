module OrdersHelper
  def status_color(status)
    {
      "pending" => "secondary",
      "accepted" => "success",
      "rejected" => "danger",
      "completed" => "primary"
    }[status] || "light"
  end
end
