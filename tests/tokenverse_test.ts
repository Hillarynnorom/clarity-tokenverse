import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can mint story fragment",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;

    let block = chain.mineBlock([
      Tx.contractCall("tokenverse", "mint-fragment",
        [types.utf8("Once upon a time...")],
        wallet1.address)
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    assertEquals(block.receipts[0].result, "(ok u1)");
  },
});

Clarinet.test({
  name: "Ensure can transfer fragment",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet1 = accounts.get("wallet_1")!;
    const wallet2 = accounts.get("wallet_2")!;

    let block = chain.mineBlock([
      Tx.contractCall("tokenverse", "mint-fragment",
        [types.utf8("Test fragment")],
        wallet1.address),
      Tx.contractCall("tokenverse", "transfer-fragment",
        [types.uint(1), types.principal(wallet2.address)],
        wallet1.address)
    ]);

    assertEquals(block.receipts.length, 2);
    assertEquals(block.receipts[1].result, "(ok true)");
  },
});
