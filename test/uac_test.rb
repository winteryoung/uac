require_relative '../lib/uac'
require 'test/unit'

class UacTest < Test::Unit::TestCase
  def test_join_args_discrete_args
    options = {
      :terminal => true,
      :pause => true
    }

    args = [
      "echo",
      "hello",
    ]

    uac_private = Uac::UacPrivate.new
    (file, rest) = uac_private.join_args options, args

    assert_equal file, "cmd"
    assert_equal '/c "echo hello & pause"', rest
  end

  def test_join_args_single_str_args
    options = {
      :terminal => true,
      :pause => true
    }

    args = [
      "cd /d c:/test && dir"
    ]

    uac_private = Uac::UacPrivate.new
    (file, rest) = uac_private.join_args options, args

    assert_equal file, "cmd"
    assert_equal '/c "cd /d c:/test && dir & pause"', rest
  end
end
