package com.example.buck_tanley.domain.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MatchDTO {
  private String status;
  private UserDTO user1;
  private UserDTO user2;
}
