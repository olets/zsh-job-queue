/**
 * Clears
 * > ts: Could not find a declaration file for module 'markdown-it-footnote'
 * error in config.mts
 */
declare module "markdown-it-footnote";

/**
 * Clears
 * > ts: Could not find a declaration file for module 'vitepress/dist/client/shared.js'
 * error in config.mts
 */
declare module "vitepress/dist/client/shared.js";

/**
 * Clears
 * > ts: Cannot find module '[snip]' or its corresponding type declarations."
 * errors on Vue imports
 */
declare module "*.vue" {
  import { defineComponent } from "vue";
  export default defineComponent;
}
