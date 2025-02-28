package com.example.buck_tanley.domain.dto;

import java.util.Objects;

import com.example.buck_tanley.domain.entity.User;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserDTO {
  private String userId;
  private String nickname;
  private String image;
  private String introduction;
  private Boolean gender;
  private Short age;
  private Short status; // 0 : 현재 비활성 상태, 1 : 활성 상태, 2 : 매칭 중인 상태, 3 : 매칭 된 상태

  public UserDTO(User user) {
    this.userId = user.getUserId();
    this.nickname = user.getNickname();
    this.image = user.getImage();
    this.introduction = user.getIntroduction();
    this.gender = user.getGender();
    this.age = user.getAge();
    this.status = user.getStatus();
  }

  public UserDTO(String userId) {
    this.userId = userId;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o)
      return true;
    if (o == null || getClass() != o.getClass())
      return false;
    UserDTO userDTO = (UserDTO) o;
    return Objects.equals(userId, userDTO.userId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(userId);
  }
}