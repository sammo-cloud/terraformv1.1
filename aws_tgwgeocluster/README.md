
Here some variable you should change to your own value in file <U>variables.tf</U>.
<BR>Remember to change it or the terraform will fail
<BR>
<BR>#Please use your own key to create a password hash and copy it to here.
<BR>variable "key_name" {
<BR>    default = "Use Your Key"
<BR>}
<BR>
<BR>variable "sickey" {
<BR>    default = "vpn12345"
<BR>}
<BR>
<BR>#Please use "openssl passwd -1" to create a password hash and copy it to here.
<BR>variable "password_hash" {
<BR>    default = "xxxxxxxxxxxx"
<BR>}
