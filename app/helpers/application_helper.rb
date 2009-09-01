require 'maruku'
require 'openssl'
require 'base64'

module ApplicationHelper
  def markdown(text)
    text.blank? ? "" : Maruku.new(text).to_html
  end

  def url_to_email(email)
    pad_string = lambda do |str, block_size|
      numpad = block_size - str.size % block_size
      return str + numpad.chr * numpad
    end
    pad_email = pad_string.call(email, 16)
    aes = OpenSSL::Cipher::Cipher.new('aes-128-cbc').encrypt
    aes.key = ENV['MAILHIDE_PRIVATE_KEY'].unpack('a2' * 16) \
                                         .map {|x| x.hex }.pack('c' * 16)
    aes.iv = "\00" * 16
    code = aes.update(pad_email) << aes.final
    c = Base64.encode64(code).gsub('+', '-').gsub('/', '_').gsub("\n", '')
    "http://mailhide.recaptcha.net/d?k=#{ENV['MAILHIDE_PUBLIC_KEY']}&c=#{c}"
  end

  def link_to_email(email)
    email[0...case email.sub(/@.*$/, '').size
                when 1..4 then 2
                when 5..6 then 3
                else 4
              end] + \
    link_to('&hellip;', url_to_email(email),
            :popup => ['toolbar=0,scrollbars=0,location=0,statusbar=0,' \
                       'menubar=0,resizable=0,width=500,height=300'],
            :title => 'Reveal this e-mail address') + \
    email.sub(/^[^@]*/, '')
  end

  def pager(length, selection = 1, step = 9)
    length = length.to_i
    selection = selection.to_i
    step = step.to_i
    half = step / 2
    if length > step && selection > half + 2
      yield("first", 1)
      i = selection + half >= length ? length - step + 1 : selection - half
    else
      i = 1
    end
    to = [i + step, 1 + length].min
    for i in i...to
      yield(i == selection ? "selected" : i, i)
    end
    yield("last", length) if [selection, to].max + 1 < length
  end
end
