module ApplicationHelper
  def default_body
    <<-BODY
Hi {{member.address.name}},

this is just a reminder that you will be receiving an invoice from us in {{days}} days.

You current plan: {{ plan.name }}
{% if plan.has_extras %}
Extras: {% for extra in plan.extras %}
{{extra.name}}: {{extra.price | money }} {{plan.currency}}
{% endfor %}{% endif %}
Price: {{plan.price | money}} {{plan.currency}}.

{% if paid_for_members %}
In addition, you are paying for these members:
{% for m in paid_for_members %}
{{m.address.name}}: {{ m.plan.name }}, {{m.plan.price | money}} {{m.plan.currency}}
{% endfor %}
{% endif %}

Please contact us beforehand if you have any questions about the invoice.
    BODY
  end
end
