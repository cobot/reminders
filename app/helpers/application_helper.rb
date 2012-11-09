module ApplicationHelper
  def default_body
    <<-BODY
Hi,

this is just a reminder that you will be receiving an invoice from us in {{days}} days.

You current plan: {{ plan.name }}
Price: {{plan.price_per_cycle | money}} {{plan.currency}}.

Please contact us beforehand if you have any questions about the invoice.
    BODY
  end
end
