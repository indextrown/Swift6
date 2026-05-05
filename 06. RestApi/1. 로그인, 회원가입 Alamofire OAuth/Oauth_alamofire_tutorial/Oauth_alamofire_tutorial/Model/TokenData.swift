//
//  TokenData.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation
/*
{
    "data": {
        "user": {
            "id": 49,
            "name": "인덱스",
            "email": "index@email.com",
            "post_count": 0,
            "avatar": "https://www.gravatar.com/avatar/cc1428530f5f57875ef2d2f3ca0884c5.jpg?s=200&d=robohash"
        },
        "token": {
            "token_type": "Bearer",
            "expires_in": 1296000,
            "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiYmFhYTUwNWNlMGRlODZmZDQ4Y2ZkNGNlNDkxYzcxYzM4YzljMjllNGU4MzkwM2QyYmM5NmQ2MGM3NTVlN2MwMzhkMDZkMDU5MzM1NmNjOWYiLCJpYXQiOjE3NDI1NDgwMjUuNTUwNzA1LCJuYmYiOjE3NDI1NDgwMjUuNTUwNzA3LCJleHAiOjE3NDM4NDQwMjUuNTM2NDI0LCJzdWIiOiI0OSIsInNjb3BlcyI6W119.pGltAXoQ5sa4uTOWImHLjMqR8tY7gC3KfEOgGmdM_KKCZgZH3_f_HBcRmGb7Kvf17T67tWyjwFh_E0k758-rfzmUTqVHBOP-BT1cj-hZkaGKlIukdNiucijbAxHGX3OR5Gh-Kpb-dIYaYuU9H0GUXUBIYcYgAiOlSsW2fzARjgkR1-ii7Ry1PiyoQ0hvPBPLHT6-33tWk4aRMzqzF2DifbIGGrXwPN47nmV6waRqHe6ZkD0NQQnaPBDjSeuJI9r_zcrWI1-GuIlBor1X7G3gWTUzleVBGm7ThULSdZiro5MHS_K_iH5iiOEguU9BOoIT5M1GaX3NKoDm27mTdAHrsOg_J7H8YA6cWpvNPa24XvfExIepu7f2eYhUNoe03lB1tUoMRBzyfV8zOVgjuhJ4T8XtdfjU9SN4XoTDYufCwQI1ph7L4Aq1bsHbZoFzZjbHGsZhEYC7mdbCUcpgF2TqiZt9z6mAM65yj24y8uf3NYPQXJuAYcbhKaNdggC3K9kC9O169CKYlh-XtU_Aom7oO3Ym21vHF5TVd8bOPP_S_cFAFK8cuvURi5_qJ-3AVd6vnhgup9BczOWqO2Dm7JiNTJCP5-5ROOg-fZhP2nMQVMAyX-qvj5ttvliufJV_ZOTwtknV-cffz9OMOMgIV0_q51X-iQxZgTZqMGG6j--dTXI",
            "refresh_token": "def502002a9e7056ee5a65b6970b9e3dd78664fef9ade5526de0346fc20fbaf0d399393b9295aa99d206bd0b595e6c4ead5cf78d805a36098cf9b37959c8ef3520a6fd4e05b2fbcf457136ceadbdc1427184f8d9f3bcc76b8ff95d71958d125163e210508ec635f8d936dd697f0aacdc5b6afa427bc9134d43c84f633277d784ea89003832f56450ac64083ccd0bce3508ad797dc89156fd33786b985d27ba2779b66f060b99d3ddcbfdb5862d9fab3d571ebf483bf636884b1c68954ecca8f148cb3b7520b49273b5de5709af8563c597c54ec3dd210124387e35509d36884dea18b9d18c351ba81c93784e7a05ef9370567d5239c1355bc7b19828d434ba75197a413cf313642a0907408e49398e75bcae1b1e946e10ef375ca7ab0da6a6f5823499289b760dc2979ef27226a2f1b937d87c451f1f3b6ce3f21e2688fbe6ed0eb8544462e6a26a5c17f40e527585f33f7cb577f09848ef943b467c7a651f86b7b4"
        }
    },
    "message": "회원가입에 성공하였습니다"
}
*/

// MARK: - TokenData
struct TokenData: Codable {
    let tokenType: String = ""
    let expiresIn: Int = 0
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
