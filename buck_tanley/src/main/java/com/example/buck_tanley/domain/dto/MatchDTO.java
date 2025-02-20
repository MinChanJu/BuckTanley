package com.example.buck_tanley.domain.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MatchDTO {
  private boolean status;
  private String userId1;
  private String userId2;
}
