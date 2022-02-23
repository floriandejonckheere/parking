# frozen_string_literal: true

# Based on https://gist.github.com/moertel/11091573
#
# Temporarily redirects STDOUT and STDERR to /dev/null
# but does print exceptions should there occur any.
# Call as:
#   suppress_output { puts 'never printed' }
#
def suppress_output
  original_stdout = $stdout.clone
  original_stderr = $stderr.clone
  $stderr.reopen File.new(File::NULL, "w")
  $stdout.reopen File.new(File::NULL, "w")
  yield
ensure
  $stdout.reopen original_stdout
  $stderr.reopen original_stderr
end
