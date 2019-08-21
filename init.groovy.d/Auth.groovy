import jenkins.model.Jenkins
import jenkins.security.QueueItemAuthenticatorConfiguration
import hudson.model.*


def generator = { String alphabet, int n ->
  new Random().with {
    (1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
  }
}
passwd = generator( (('A'..'Z')+('a'..'z')+('0'..'9')).join(), 16 )

println("=== Configuring users")

def securityRealm = Jenkins.instance.getSecurityRealm()
User admin = securityRealm.createAccount("admin", passwd)
admin.setFullName("admin")
println("admin login: "+passwd)

passwd2 = generator( (('A'..'Z')+('a'..'z')+('0'..'9')).join(), 16 )
User user1 = securityRealm.createAccount("user1", passwd2)
user1.setFullName("user1")
println("user1 login: "+passwd2)
