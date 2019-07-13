package com.xtiva.cd;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@RunWith(MockitoJUnitRunner.class)
public class ApplicationBootstrapHealthControllerTest {

  @InjectMocks
  ApplicationBootstrapHealthController controller = new ApplicationBootstrapHealthController();

  private MockMvc mvc = MockMvcBuilders.standaloneSetup(controller)
      .build();

  @Test
  public void testHealthyEndpoint() throws Exception {
    mvc.perform(get("/api/health"))
        .andExpect(status().isOk());
  }
}
