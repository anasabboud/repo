import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.logging.Level;
import java.util.logging.Logger;

@RestController
public class HelloWorld{

  private static final Logger LOG = Logger.getLogger(HelloWorld.class.getName());

  public static void main(String[] args) throws Exception{
 
    System.out.println("HelloWorld");

  }

  @RequestMapping("/aela2")
  public String forward() {
    LOG.log(Level.INFO , "aela2 has been called");
    return "aela2 has been called";
  }

}
