package com.xtiva.cd;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@RunWith(MockitoJUnitRunner.class)
public class TestControllerTest {
  
  @InjectMocks
  TestController controller = new TestController();
  
  private MockMvc mvc = MockMvcBuilders.standaloneSetup(controller)
      .build();
  
  @Test
  public void testHealthyEndpoint() throws Exception {
    MvcResult result = mvc.perform(get("/api/test")).andReturn();
    Assert.assertEquals("Hello World", result.getResponse().getContentAsString());
  }

}
