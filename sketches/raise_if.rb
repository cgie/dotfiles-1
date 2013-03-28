# == raise_if
#
# Evaluate the +predicate+ in a `if clause`
# and if it return +true+ raises the given +exception+
def raise_if(predicate, exception, message='')
  if predicate
    raise exception, message
  end
end

def raise_if_test(number)
  universal_answer_to_everything = 42
  raise_if number != universal_answer_to_every_thing,
    ArgumentError,
    "#{number} is WRONG"
  p "done"
end