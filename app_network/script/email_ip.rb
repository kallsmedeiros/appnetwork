#!/usr/bin/ruby

while 1 > 0 do

 emails = File.readlines('/home/carlos/tcc/app_network/script/email.txt')
 array_email = []
 emails.each do |email|
   j = 0
   e = ''
   while email[email.size-1] != email[j] do
    e << email[j]
    j = j+1
   end
   array_email << e
 end

ip_public = `curl ifconfig.co`
puts "***********************************************************************************************************************************************"

a = ip_public.scan(/\w+/)
ip = "#{a[0]}.#{a[1]}.#{a[2]}.#{a[3]}"
puts "E-mails: #{array_email}"
puts ip

  array_email.each do |email|
   `echo "Acesse:  #{ip}" | mutt -s "IP ACESSO" #{email}`
  end
puts "Enviado"
`sleep 900`
end
