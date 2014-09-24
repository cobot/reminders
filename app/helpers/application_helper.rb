module ApplicationHelper
  def default_body
    <<-BODY
Hi {{member.address.name}},

this is just a reminder that you will be receiving an invoice from us in {{days}} days.

You current plan: {{ plan.name }}
Price: {{plan.price_per_cycle | money}} {{plan.currency}}.

{% if paid_for_members %}
You are paying for these member:
{% for m in paid_for_members %}
{{m.address.name}}: {{ m.plan.name }}, {{m.plan.price_per_cycle | money}} {{m.plan.currency}}
{% endfor %}
{% endif %}

Please contact us beforehand if you have any questions about the invoice.
    BODY
  end
end
