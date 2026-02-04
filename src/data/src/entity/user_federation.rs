use crate::database::DB;
use hiqlite_macros::params;
use rauthy_common::is_hiqlite;
use rauthy_error::ErrorResponse;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserFederation {
    pub user_id: String,
    pub provider_id: String,
    pub federation_uid: String,
}

impl From<tokio_postgres::Row> for UserFederation {
    fn from(row: tokio_postgres::Row) -> Self {
        Self {
            user_id: row.get("user_id"),
            provider_id: row.get("provider_id"),
            federation_uid: row.get("federation_uid"),
        }
    }
}

impl UserFederation {
    pub async fn create(
        user_id: String,
        provider_id: String,
        federation_uid: String,
    ) -> Result<Self, ErrorResponse> {
        let new_federation = Self {
            user_id,
            provider_id,
            federation_uid,
        };

        let sql = "INSERT INTO user_federations (user_id, provider_id, federation_uid) VALUES ($1, $2, $3)";
        if is_hiqlite() {
            DB::hql()
                .execute(
                    sql,
                    params!(
                        &new_federation.user_id,
                        &new_federation.provider_id,
                        &new_federation.federation_uid
                    ),
                )
                .await?;
        } else {
            DB::pg_execute(
                sql,
                &[
                    &new_federation.user_id,
                    &new_federation.provider_id,
                    &new_federation.federation_uid,
                ],
            )
            .await?;
        }

        Ok(new_federation)
    }

    pub async fn find_for_user(user_id: &str) -> Result<Vec<Self>, ErrorResponse> {
        let sql = "SELECT * FROM user_federations WHERE user_id = $1";
        if is_hiqlite() {
            let res = DB::hql().query_as(sql, params!(user_id)).await?;
            Ok(res)
        } else {
            let res = DB::pg_query(sql, &[&user_id], 10).await?;
            Ok(res)
        }
    }

    pub async fn find_by_federation_id(
        provider_id: &str,
        federation_uid: &str,
    ) -> Result<Self, ErrorResponse> {
        let sql = "SELECT * FROM user_federations WHERE provider_id = $1 AND federation_uid = $2";
        let res = if is_hiqlite() {
            DB::hql()
                .query_as_one(sql, params!(provider_id, federation_uid))
                .await?
        } else {
            DB::pg_query_one(sql, &[&provider_id, &federation_uid]).await?
        };
        Ok(res)
    }

    pub async fn delete(
        &self,
    ) -> Result<(), ErrorResponse> {
        let sql = "DELETE FROM user_federations WHERE user_id = $1 AND provider_id = $2";
        if is_hiqlite() {
            DB::hql()
                .execute(sql, params!(&self.user_id, &self.provider_id))
                .await?;
        } else {
            DB::pg_execute(sql, &[&self.user_id, &self.provider_id]).await?;
        }
        Ok(())
    }

    pub async fn delete_by_user_id(
        user_id: &str,
    ) -> Result<(), ErrorResponse> {
        let sql = "DELETE FROM user_federations WHERE user_id = $1";
        if is_hiqlite() {
            DB::hql()
                .execute(sql, params!(user_id))
                .await?;
        } else {
            DB::pg_execute(sql, &[&user_id]).await?;
        }
        Ok(())
    }
}
