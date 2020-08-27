

# Create Database

```
% sqlite3 db/db.sqlite3 < sql/make_db.sql
```

# Supplement (Initial Settings)

```
% npm init -y
% npm install -D spago purescript
% npx spago init
% npm install sqlite3
% npx spago install node-process node-sqlite3 simple-json bucketchain
```


# メモ

今の時点では、ちょっときついかな、、、。
HalogenのComponent, mkComponent, unComponent
を参考にすると良い？


https://github.com/purescript-contrib/purescript-aff/blob/master/src/Effect/Aff/Class.purs
で定義されている

class MonadEffect m ⇐ MonadAff m where
  liftAff ∷ Aff ~> m

instance monadAffReader ∷ MonadAff m ⇒ MonadAff (ReaderT r m) where
  liftAff = lift <<< liftAff

を使って、AffモナドをEffectモナドに変換出来る？
つまり、Aff (Array result) -> Effect (Array result)

これを使うと、
liftAff (Aff x) が (m x) になるはず。
つまり、r->m aという関数fを用意しておいて、
liftAff (Aff (ReaderT f) ) が Effect (ReaderT f) になるはず。

fは、constでも良いが、結果は何かのmonadで囲まれている必要がある。
f = ReaderT ( (const $ pure unit) :: Effect Unit)

こうすると、
x :: Effect ReaderT
(ReaderT f) <- liftAff $ pure f :: Aff ReaderT



(ReaderT f) <- liftAff do
  pure ReaderT $ \x -> (pure 123 :: Effect Int)
y <- f 1
log $ show y

