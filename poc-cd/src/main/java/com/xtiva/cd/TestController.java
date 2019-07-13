package com.xtiva.cd;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller to handle the health of the service.
 *
 * @author Alejandro Calderon Velez
 */
@RestController
@RequestMapping("/api/test")
public class TestController {
  /**
   * Obtains the http code of the health of the service.
   *
   * @return http code of the health of the service.
   */
  @RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  @ResponseBody
  public String getTest() {
    return "Hello World";
  }

}
