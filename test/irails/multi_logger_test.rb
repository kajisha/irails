require 'stringio'
require 'test_helper'
require 'irails/logger'

class MultiLoggerTest < IRailsTest
  def test_multilogger
    out, err = StringIO.new, StringIO.new
    logger = IRails::MultiLogger.new(Logger.new(out), Logger.new(err))
    logger.warn 'You did a bad thing'
    assert_match 'WARN', out.string
    assert_match 'WARN', err.string
    assert_match 'bad thing', out.string
    assert_match 'bad thing', err.string
  end
end
