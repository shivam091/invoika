# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module FilesHelper
  # Returns filesize in a human readable format with units.
  # Uses the binary JEDEC unit system, i.e. 1.0 KB = 1024 bytes
  PRETTIFY_FILESIZE = lambda do |bytes|
    file_size_units = I18n.t(".file_size_units").freeze
    return "0.0 B" if bytes == 0

    exp = Math.log(bytes, 1024).floor
    max_exp = file_size_units.length - 1
    exp = max_exp if exp > max_exp
    "%.2f %s" % [bytes.to_f / 1024 ** exp, file_size_units[exp]]
  end
end
